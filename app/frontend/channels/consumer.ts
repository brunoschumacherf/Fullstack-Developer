import { createConsumer } from "@rails/actioncable"

type Consumer = ReturnType<typeof createConsumer>

let consumer: Consumer | undefined

export default function getConsumer() {
  consumer ??= createConsumer()
  return consumer
}
