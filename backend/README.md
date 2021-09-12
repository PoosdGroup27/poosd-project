### Running backend locally
- Clone repo
- `cd` into backend directory
- If needed, install poetry from https://python-poetry.org/docs/
- `poetry install`
- `poetry run start`
- Application will be running at localhost:8000
- Changes to source code are reflected on reload with no need to rerun start script

### API Schema Info
- Schema + ability to make requests at `{host}/docs`
- OpenAPI schema at `{host}/openapi.json` // we can later use this when defining APIGateway