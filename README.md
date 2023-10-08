# Matrix Sender
---

This script allows you to send simple unencrypted message & html to matrix.
It can be usefull for logging / cronjobs error or monitoring.

## Install

This script **is dependent of jq & curl**.

To install the script, just clone this repo:
```sh
git clone https://git.arka.rocks/Oxbian/matrix-sender
```

And if you want you can add it to the PATH or link it to the `/bin` folder.
```sh
sudo ln -s $(pwd)/matrix-sender /bin/matrix-sender
```

## Usage

First you need to edit the script with your homeserver url & the roomID

After this you need to get your token
```sh
./matrix-sender -t <username> <password>
```

Once all is setup, you can send messages:
- Simple message
```sh
./matrix-sender -s <message>
```

- or an HTML formatted message
```sh
./matrix-sender -html <message>
```

For help you can use:
```sh
./matrix-sender -h
```
or
```sh
./matrix-sender --help
```

**Example**
```bash
./matrix-sender -s 'Hello world!'
```

```bash
./matrix-sender -html '<h1 class="test"> t e s t </h1>'
```

## Contributing

If you want to contribute, make a pull request with your contribution.

## License

This project is under the GPLv3 license, you can use it in your project but not in closed sources ones.
Sharing project is what make the world live, think about it.

