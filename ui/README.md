# cobudget-ui

cobudget's user interface. For more information on the project as a whole, check out the [top-level repo](https://github.com/cobudget/cobudget)

---

## Install

### Install node v8

Install node and npm from the [node.js homepage](https://nodejs.org)

### Download and install cobudget-ui

```
git clone https://github.com/cobudget/cobudget
cd cobudget/ui
npm install
```

### Configuration

The cobudget frontend needs to know where to find the backend. Currently it's configured for three different backends:

* `development`: Will connect to a backend running locally on your development machine.
* `staging`: Will connect to the backend running on the current cobudget staging server.
* `production`: Will connect to the backend running on the current cobudget production server.

Choose which backend to connect to using the environment variable `NODE_ENV`

`$ export NODE_ENV=staging`

If NODE_ENV is not set it will default to using `development`

The actual connection strings is placed in the js files in the `config` directory

### Build and run

Build and start server using live reload: `npm run develop`

Build once and start static server: `npm start`

Connect to the front end on [http://localhost:9000](http://localhost:9000)

## Deploy

The deployment to production and stage is done by pushing to github pages. 

First configure `git` to remember deploy destinations. This is only needed once.

For stage: `npm run set-remote-stage`

For production: `npm run set-remote`

### Actual deployment

Deploy to stage: `npm run stage`

The deployed frontend will be configured to connect to the backend stage environment.

Deploy to production: `npm run deploy`

The deployed frontend will be configured to connect to the backend production environment.
