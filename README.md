# SNODAS Tools UI

This repo contains the static files implementing the UI for the PSU CSAR SNODAS
Tools project.

The backend implementation [can be found
here](https://github.com/PSU-CSAR/django-snodas).

# Development

Running the UI locally is trivial with any simple HTTP server, such as
python's:

```cmdline
python -m http.server -d webroot/
```

The CORS settings for the SNODAS API allow `localhost:8000`, `localhost:8080`,
and `localhost:3000` to accommodate the default port for a variety of local
http servers.

# Deployment

The production deployment of this UI uses IIS. A script automating the IIS
configurations steps is included (`./bin/install_iis_site.bash`). Run it using
a Windows bash implementation, such as cygwin or the git-bash shell that comes
with git for Windows.
