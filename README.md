# CloudexCli

## Installation
  1. Clone the repository.
  2. Go to the repository directory
  3. Run ```mix deps.get```
  4. Run ```mix escript.build```
  5. you will now have a binary called ```cloudex_cli```

## Configuration

By default cloudex will look for a dotfile in
```~/.cloudex.conf```

This file should contain the following settings :
```
api_key: YOU_CLOUDINARY_API_KEY
secret: YOU_CLOUDINARY_SECRET
cloud_name: YOU_CLOUDINARY_CLOUD_NAME
```

* alternatively you can set the following ENV vars :
```CLOUDEX_API_KEY```
```CLOUDEX_SECRET```
```CLOUDEX_CLOUD_NAME```

* Lastly its also possible to give these settings with the command like, for example :

```bash
cloudex --api-key=YOU_CLOUDINARY_API_KEY --secret=YOU_CLOUDINARY_SECRET --cloud-name=YOU_CLOUDINARY_CLOUD_NAME ./image.jpg
```
