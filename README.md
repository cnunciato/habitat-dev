# habitat-support

This is what I've been using in development (on my Mac) with Vagrant and VirtualBox. (This repo sits alongside my `habitat` repo.)

## To use it...

Clone this repository into a directory alongside the `habitat` and `core-plans` repos. (The Vagrantfile assumes the presence of both, as well as the existence of `~/.hab/cache/keys`). For example:

```
├── habitat
├── core-plans
├── habitat-support
```

Next, make a copy of `scripts/my.env.example` and name it `scripts/my.env`, supplying your GitHub auth token and whatever additional environment variables you'd to have pulled into your environment.

```
vagrant up
```

This loads a bunch of required dev tooling. It usually takes around 10 minutes or so. When it finishes:

```
vagrant ssh
sudo -i
cd /support
make run
```

... to start up the Builder services. This usually takes a bit longer.

While that's running, if you haven't already, [download a package archive](http://nunciato-shared-files.s3.amazonaws.com/pkgs.zip) and unpack it into `./pkgs`. Vagrant will share the directory into the VM as `/hab/cache/artifacts`.

When the `make run` logging quiets down, you should have a running cluster. Leave it going, and in another tab:

```
vagrant ssh
sudo -i
cd /support
make load
```

This will create the core origin, upload its keys, and upload all of the packages in the archive I mentioned above.

Once the upload completes (which usually takes quite a bit longer), you shoudl be able create a new project and submit a job for it:

```
make project
make job
```

