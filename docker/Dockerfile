# Free Pascal compiler in a Debian container
# Build:  docker build -t fpc docker/
# Use:    docker run --rm -v "$PWD":/src fpc fpc DaysUntil.pas

FROM debian:stable-slim

# fpc pulls in the compiler, standard units and binutils (ld linker).
# locales is needed so the clocale unit can use e.g. nl_NL date formats.
RUN apt-get update \
 && apt-get install -y --no-install-recommends fpc locales \
 && sed -i 's/^# *\(nl_NL.UTF-8\)/\1/; s/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Default locale (override with -e LANG=...)
ENV LANG=nl_NL.UTF-8 \
    TZ=Europe/Amsterdam

WORKDIR /src

CMD ["bash"]
