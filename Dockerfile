FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal
# Set automatically by BuildKit (amd64 / arm64)
ARG TARGETARCH
RUN case "${TARGETARCH}" in \
      amd64) arch=x86_64 ;; \
      arm64) arch=aarch64 ;; \
      *) echo "unsupported arch: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
  && rpm -i "https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-${arch}.rpm" \
  && mkdir -p /home/emulator && chown 1000 /home/emulator
USER 1000
ENV HOME=/home/emulator
EXPOSE 9297
ENTRYPOINT ["aws-emulator", "-b", "0.0.0.0"]
