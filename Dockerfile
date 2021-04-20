FROM --platform=$BUILDPLATFORM golang:1.16-alpine AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src
ENV CGO_ENABLED=0
COPY . .
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/hello-world-${TARGETOS}-${TARGETARCH} helloworld.go

#FROM scratch AS bin
#COPY --from=build /log /log
#COPY --from=build /out/* /

FROM scratch AS binaries-unix
COPY --from=build /out/* /

FROM binaries-unix AS binaries-darwin
FROM binaries-unix AS binaries-linux

FROM scratch AS binaries-windows
COPY --from=build /out/hello-world-windows-amd64 /hello-world-windows-amd64.exe

FROM binaries-$TARGETOS AS binaries
