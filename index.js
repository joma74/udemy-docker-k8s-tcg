const express = require("express")

const app = express()

app.get("/", (rq, rs) => {
    rs.send("How are you?")
})

const port = 8080

app.listen(port, () => {
    console.log(`Listening on port ${port}`)
})