# Matrix Sender
------

This script allows you to send simple unencrypted message & html to matrix.
It can be usefull for logging / cronjobs error or monitoring.

## Install

This script **is dependent of jq & curl**.

To install the script, just clone this repo:
```bash
git clone https://github.com/oxbian/matrix-sender.git
```

## Usage

First you need to edit the script with your homeserver url & the roomID

After this you need to get your token
```bash
./matrix.sh -t <username> <password>
```

Once all is setup, you can send messages:
- Simple message
```bash
./matrix.sh -s <message>
```

- HTML formatted message
```bash
./matrix.sh -html <message>
```

For help you can use:
```bash
./matrix.sh -h
```

```bash
./matrix.sh --help
```

**Exemple**
```bash
./matrix.sh -s 'Hello world!'
```

```bash
./matrix.sh -html '<h1 class="test"> t e s t </h1>'
```

## Contributing

If you want to contribute, make a pull request with your contribution.

## License

This project is under the GPLv3 license, you can use it in your project but not in closed sources ones.
Sharing project is what make the world live, think about it.

