import React, { Component } from "react"
import axios from "axios"

export default class Fib extends Component {
	state = {
		seenIndexes: [],
		values: {},
		index: "",
	}

	componentDidMount() {
		this.fetchValues()
		this.fetchIndexes()
	}

	async fetchIndexes() {
		await axios
			.get("/api/values/all")
			.then((seenIndexes) => {
				this.setState({ seenIndexes: seenIndexes.data })
			})
			.catch((err) => {
				console.log("Error " + err.message)
			})
	}

	async fetchValues() {
		await axios
			.get("/api/values/current")
			.then((values) => {
				this.setState({ values: values.data })
			})
			.catch((err) => {
				console.log("Error " + err.message)
			})
	}

	/**
	 * @param {React.FormEvent<HTMLFormElement>} event
	 */
	handleSubmit = async (event) => {
		event.preventDefault()

		await axios.post("/api/values", {
			index: this.state.index,
		})
		this.setState({ index: "" })
	}

	renderSeenIndexes() {
		return this.state.seenIndexes.map(({ number }) => number).join(", ")
	}

	renderValues() {
		const entries = []
		for (let key in this.state.values) {
			entries.push(
				<div key={key}>
					For index {key} I calculated {this.state.values[key]}
				</div>,
			)
		}
		return entries
	}

	render() {
		return (
			<div>
				<form onSubmit={(event) => this.handleSubmit(event)}>
					<label>Enter your index:</label>
					<input
						value={this.state.index}
						onChange={(event) => this.setState({ index: event.target.value })}
					/>
					<button>Submit</button>
				</form>
				<h3>Indexes I have seen:</h3>
				{this.renderSeenIndexes()}
				<h3>Calculated Values:</h3>
				{this.renderValues()}
			</div>
		)
	}
}
