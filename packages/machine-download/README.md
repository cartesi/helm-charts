# Cartesi Machine Download

This Docker image provides an utility to download Cartesi Machines stored in IFPS using the [CAR](https://ipld.io/specs/transport/car/carv1/) format, and extracting to a local folder.

## Usage

The following command will download the Cartesi Machine with the given hash and extract it to the given folder:

```shell
docker run -t cartesi/machine-download:devel bafybeibdpcfqtcqhgjzmo5wzi3kraxdu6f4wm2hzna4tj2enkepzvldjtq /tmp
```

Obviously, the output directory can be in a volume mapped to outside the docker container.
