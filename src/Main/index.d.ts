// WARNING: Do not manually modify this file. It was generated using:
// https://github.com/dillonkearns/elm-typescript-interop
// Type definitions for Elm ports

export namespace Elm {
  namespace Main {
    export interface App {
      ports: {
        requestLogin: {
          subscribe(callback: (data: null) => void): void
        }
        requestLogout: {
          subscribe(callback: (data: null) => void): void
        }
        setAuthState: {
          send(data: unknown): void
        }
      };
    }
    export function init(options: {
      node?: HTMLElement | null;
      flags: { width: number; height: number };
    }): Elm.Main.App;
  }
}