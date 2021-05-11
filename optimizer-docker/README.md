## Introduction
This is just a fork from [ampproject/toolbox-optimizer](https://hub.docker.com/r/ampproject/toolbox-optimizer).  
[ampproject/toolbox-optimizer](https://hub.docker.com/r/ampproject/toolbox-optimizer) is a [Docker](https://www.docker.com/) container that exposes an [AMP Optimizer](https://github.com/ampproject/amp-toolbox/tree/main/packages/optimizer) server for optimizing your amphtml using the same server-side-rendering optimizations as the [Google AMP Cache](https://developers.google.com/amp/cache).

## How it works

The AMP Optimizer server accepts `POST` requests at port `3000` and requires an HTML body. It then runs the HTML through the [optimizer](https://github.com/ampproject/amp-toolbox/tree/main/packages/optimizer) package, and returns the result as the response.

## Configuration

There are two different kinds of configuration you can supply to the container:
1. Static configuration via environment variables: On startup, the container will search for environment variables prefixed with `AMP_OPTIMIZER_` and pass the values as configuration options when initializing the underlying optimizer library. The full list of options are available [here](https://github.com/ampproject/amp-toolbox/tree/main/packages/optimizer#options). Options should be specified in SCREAMING_SNAKE_CASE as opposed to camelCase. For example, in order to configure the `optimizeHeroImages` option, you would declare the environment variable named: `AMP_OPTIMIZER_OPTIMIZE_HERO_IMAGES`.
2. Per-request configuration: there are some options that can only be set on a per-request basis. For example, the `canonical` flag for specifying an AMP page's canonical link. These can be specified via query params, e.g. `/?canonical=http://example.com`.
