#!/usr/bin/env bash

GRAAL_VM_DOCKER_IMAGE=springci/graalvm-ce:20.2-dev-java11

jar=$(ls target/clojure-lsp-*-standalone.jar)

outfile="/clojure-lsp/$jar"

# lein with-profiles +clojure-1.10.2,+native-image "do" clean, uberjar

args=( "-jar" "$outfile"
              "-H:Name=clojure-lsp"
              "-H:+ReportExceptionStackTraces"
              "-J-Dclojure.spec.skip-macros=true"
              "-J-Dclojure.compiler.direct-linking=true"
              "-H:ReflectionConfigurationFiles=/clojure-lsp/graalvm/reflection.json"
              "--initialize-at-build-time"
              "--initialize-at-run-time=org.apache.log4j.LogManager"
              "-H:+TraceClassInitialization"
              "-H:IncludeResources='db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.xml|.*.conf'"
              "--report-unsupported-elements-at-runtime"
              "-H:Log=registerResource:"
              "--verbose"
              "--no-fallback"
              "--no-server"
              "--static"
              "-J-Xmx3g" )

docker run --rm -v ${PWD}:/clojure-lsp $GRAAL_VM_DOCKER_IMAGE native-image "${args[@]}"
