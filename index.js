const express = require("express")
const redis = require("redis")
const process = require("process")

const app = express()
const client = redis.createClient({
	host: "redis-server"
})

const visits_key = "visits"

client.set("visits", "0")

app.get("/", (req, res) => {
	process.exit(1)
	client.get(visits_key, (err, visits) => {
		if (err) {
			res.status(500).send(JSON.stringify(err))
		} else {
			res.send(`Number of visits is ${visits}`)
			client.set(visits_key, (parseInt(visits) + 1).toString())
		}
	})
})

const port = 8081

app.listen(port, () => {
	console.log(`Listening on port ${port}`)
})
