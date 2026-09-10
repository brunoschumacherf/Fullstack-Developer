declare module "@rails/actioncable" {
  export function createConsumer(url?: string): {
    subscriptions: {
      create: (
        channel: string | Record<string, unknown>,
        mixin?: Record<string, unknown>,
      ) => { unsubscribe: () => void }
    }
  }
}
