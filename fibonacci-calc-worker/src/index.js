var debug = require("debug")("fibonacci-calc-worker")

const keys = require("./keys")
const redis = require("redis")
const util = require("util")

if (keys.redisHost === undefined || keys.redisPort === undefined) {
	const errorMsg = util.format(
		"Required process.env.REDIS_HOST:process.env.REDIS_PORT to be set but was %s:%d",
		keys.redisHost,
		keys.redisPort
	)
	debug(errorMsg)
	throw new Error(errorMsg)
}

// see https://nodejs.org/api/util.html#util_util_inspect_object_options
debug("Connecting to redis at %s:%d", keys.redisHost, keys.redisPort)

const redisCommander = redis.createClient({
	host: keys.redisHost,
	port: parseInt(keys.redisPort),
	retry_strategy: () => 1000
})

// See http://redis.js.org/#extras-clientduplicateoptions-callback
const redisSubscriber = redisCommander.duplicate()

/**
 * Implements the algorithmic for fibonacci number calculation
 *
 * @param {number} index
 */
function fib(index) {
	if (index < 2) return 1
	return fib(index - 1) + fib(index - 2)
}

redisSubscriber.on("message", (channel, message) => {
	debug("Recieved on channel '%s'", message)
	/**
	 * See https://redis.io/commands/hset
	 * Set the field in the hash(variadic:map) stored at key to value. If
	 * the key does not exist, a new key holding a hash is created.
	 * If the field already exists in the hash, it is overwritten.
	 */
	redisCommander.hset("values", message, fib(parseInt(message)), redis.print)
})
// subscribe to inserts
redisSubscriber.subscribe("insert", redis.print)
