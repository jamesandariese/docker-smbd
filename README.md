## docker smbd

A dockerized smbd

```
docker run -i -d --net=host -e VOLUMES="share1;/mnt/vol1;share2;/mnt/vol2" -e USERS="james;1000;ENCRYPTEDPASSWORDSEEBELOW" jamesandariese/smbd
```

#### to get an encrypted password

```
docker run -ti jamesandariese/smbcrypt
```
