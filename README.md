# habitat-support

This is what I've been using in development (on my Mac) with Vagrant and VirtualBox. (This repo sits alongside my `habitat` repo.)

## To use it...

Clone this repository into a directory alongside the `habitat` and `core-plans` repos. (The Vagrantfile assumes the presence of both, as well as the existence of a `~/.hab/cache/keys` directory with some keys in it.)

```
/Users/you/where-your-code-lives
├── habitat
├── core-plans
├── habitat-support
```

and in your home directory:

```
/Users/you
.hab
└── cache
    └── keys
        ├── core-20160612031944.pub
        ├── core-20160810182414.pub
        ├── core-20160810182414.sig.key
        ...
```

You'll need all three of these keys, by the way. If you don't see one or more them, you can download the public ones with `hab`:

```
hab origin key download core 20160612031944
hab origin key download core 20160810182414
```

The private/signing key is in 1Password.

Next, make a copy of `scripts/my.env.example` and name it `scripts/my.env`, supplying your GitHub auth token and whatever additional environment variables you'd to have pulled into your environment. Once that file is saved, in the root of this repo (not the `habitat` repo &mdash; this one), run:

```
vagrant up
```

This provisions the development VM and installs a bunch of useful tooling. It usually takes around 10 minutes or so. When it finishes, go into the VM, switch to the `root` user, change to the `/support` directory, and run `make`:

```
vagrant ssh
sudo -i
cd /support
make
```

This start up the Builder services. It usually takes a bit longer.

While that's running, if you haven't already, [download a package archive](http://nunciato-shared-files.s3.amazonaws.com/pkgs.zip) and unpack it into `./pkgs` (on your computer now, not on the VM; this directory is shared into the VM, but you'll want to keep it around between VM provisionings). Vagrant will share the `./pkgs` directory into the VM at `/hab/cache/artifacts`.

When the `make` logging quiets down, you should have a running cluster. Leave it running, and in another tab, once again, enter the VM, change to `root`, navigate to `/support`, and run `make load`:

```
vagrant ssh
sudo -i
cd /support
make load
```

This will create the core origin, upload its keys, and upload all of the packages in the `./pkgs` directory you created above.

Once the upload completes (which usually takes quite a bit longer), you should be able create a new project and submit a job for it:

```
make project
make job
```
