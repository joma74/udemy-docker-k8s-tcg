var debug = require("debug")("fibonacci-calc-server")

const keys = require("./keys")

const express = require("express")
const bodyParser = require("body-parser")
const cors = require("cors")
const redis = require("redis")

const util = require("util")

// Express
const server = express()
server.use(cors())
server.use(bodyParser.json())

// POSTGRES
const { Pool } = require("pg")
/**
 * @type {import('pg').PoolConfig}
 */
const pgDataSource = {
	host: keys.pgHost,
	port: parseInt(keys.pgPort),
	user: keys.pgUser,
	password: keys.pgPassword,
	database: keys.pgDatabase,
}

debug("Connecting to postgres via %j", pgDataSource)
const pgClient = new Pool(pgDataSource)
pgClient.on("error", (err) => debug("Lost postgres connection %o", err))

pgClient
	.query("CREATE TABLE IF NOT EXISTS values (number INT)")
	.catch((err) => debug("Could not create table %o", err))

// REDIS
/**
 * @type {import('redis').ClientOpts}
 */
const redisConnection = {
	host: keys.redisHost,
	port: parseInt(keys.redisPort),
	retry_strategy: () => 1000,
}

debug("Connecting to redis via %j", redisConnection)
const redisCommander = redis.createClient(redisConnection)
const redisPublisher = redisCommander.duplicate()

// MAIN

server.get("/", (rq, rs) => {
	debug("/ request recieved, sending teapot")
	rs.status(418).send("I'm a teapot")
})
server.get("/values/all", async (rq, rs) => {
	debug("/values/all request recieved")
	const values = await pgClient.query("Select * from values")
	rs.send(values.rows)
})

server.get("/values/current", async (rq, rs) => {
	debug("/values/current request recieved")
	redisCommander.hgetall("values", (err, values) => {
		rs.send(values)
	})
})

server.post("/values", async (rq, rs) => {
	const index = rq.body.index
	debug("/values request recieved for an index of %s", index)
	if (parseInt(index) > 40) {
		debug("rejecting request, provide smaller index than 40")
		return rs.status(422).send("Provide smaller index than 40")
	}
	redisCommander.hset("values", index, "Nothing yet!")
	redisPublisher.publish("insert", index)
	pgClient.query("INSERT INTO values(number) VALUES($1)", [index])

	rs.send({ done: true })
})

const SERVER_PORT = 5000
debug("Will listen on port %s", SERVER_PORT)

server.listen(SERVER_PORT, (err) => {
	debug("Listening on port %s", SERVER_PORT)
})
