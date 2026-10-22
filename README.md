# demo-app

Tiny HTTP service used in my [homelab](https://github.com/peterkroushovsky/homelab)
to practise containers, Kubernetes, CI/CD and GitOps. Go standard library only.

## Endpoints

| Path | Purpose |
| --- | --- |
| `GET /` | App name, version, message and hostname (shows which pod answered) |
| `GET /healthz` | Liveness probe |
| `GET /readyz` | Readiness probe; returns 503 during shutdown |

## Configuration

| Variable | Default |
| --- | --- |
| `PORT` | `8080` |
| `APP_MESSAGE` | `Hello from demo-app` |

## Development

```sh
make run     # start locally
make test    # tests with race detector and coverage
make build   # static binary in bin/
```
