[![version](https://img.shields.io/badge/firefox-61-green.svg?style=flat-square)](https://packages.ubuntu.com/bionic/firefox) [![build](https://img.shields.io/docker/build/deepsweet/firefox-headless-remote.svg?label=build&style=flat-square)](https://hub.docker.com/r/deepsweet/firefox-headless-remote/) [![size](https://img.shields.io/microbadger/image-size/deepsweet/firefox-headless-remote.svg?label=size&style=flat-square)](https://microbadger.com/images/deepsweet/firefox-headless-remote)

Dockerized Firefox in headless [Marionette](https://vakila.github.io/blog/marionette-act-i-automation/) mode.

## Usage

```sh
docker pull deepsweet/firefox-headless-remote:61
docker run -it --rm --shm-size 2g -p 2828:2828 deepsweet/firefox-headless-remote:61
```

Example using [Foxr](https://github.com/deepsweet/foxr):

```js
import foxr from 'foxr'

(async () => {
  try {
    const browser = await foxr.connect()
    const page = await browser.newPage()

    await page.goto('https://example.com')
    await page.screenshot({ path: 'example.png' })
    await browser.close()
  } catch (error) {
    console.error(error)
  }
})()
```

## Related

* [chromium-headless-remote](https://github.com/deepsweet/chromium-headless-remote)
