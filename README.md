# Checkpoint Charlie

## A Quick Start

### Authentification

### Defining Jobs

```json
  {
      "id": "wba0:raft", //autogenerated from name, job id = appcode + ':'+slug(job name) 
      "is_enabled": true, //defaults true
      "meta_data": {}, // store anything you want - can be used by app 
      "name": "WBA0/RAFT",  // name should be APPCODE/JOB NAME
      "start_run_by_cron": "* 4 * * *", // a cron statement indicating when the job is expected to run.
      "grace": 5, // grace period in minutes. Any job later than start_run_by_cron + grace will be in error
      "checkpoints": [
          {
              "id": "control-file-received", //slug of name
              "meta_dat": {}, 
              "name": "Control File Received"
          },
          {
              "id": "spark-jobs-filtering",
              "meta_dat": {},
              "name": "Spark Jobs Filtering"
          },
          {
              "id": "collating-and-Decorating-filtered-files",
              "meta_dat": {},
              "name": "Collating and Decorating Filtered Files"
          },
          {
              "id": "uploading-file",
              "meta_dat": {},
              "name": "Uploading Files"
          }
      ]
  }
```


#### Setting a Job Definintion

```
curl -k $Charlie_SERVICE/api/jobs/ \
     -X POST \
     -H "Authentification: Token Some_Sometoken" \
     -H "Content-Type: application/json" \
     -d '{
      "name": "WBA0/RAFT",  
      "start_run_by_cron": "* 4 * * *",
      "grace": 5,
      "checkpoints": [
          {
              "name": "Control File Received"
          },
          {
              "name": "Spark Jobs Filtering"
          },
          {
              "name": "Collating and Decorating Filtered Files"
          },
          {
              "name": "Uploading Files"
          }
      ]
  }'
```

```
HTTP/1.0 201 Created
```












## Runing Checkpoint Charlie

To start your Checkpoint server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`




Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
