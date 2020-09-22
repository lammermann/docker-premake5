FROM alpine:latest AS builder

RUN apk add --no-cache --no-progress build-base git

WORKDIR /home/builder/
RUN git clone --single-branch --branch v5.0.0-alpha12 https://github.com/premake/premake-core.git
RUN cd ./premake-core && \
  make -f Bootstrap.mak linux && \
  ./bin/release/premake5 embed && \
  ./bin/release/premake5 gmake && \
  make
RUN strip ./bin/release/premake5

FROM alpine:latest
WORKDIR /home/premake
COPY --from=builder /home/builder/premake-core/bin/release/premake5 .
ENV PATH="${PATH}:/home/premake"
