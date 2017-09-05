# habitat-support

This project is what I use to do Habitat development on my Mac with Vagrant and VirtualBox. It sits alongside my `habitat` and `core-plans` repos, and its goal is to make it easy to set up and tear down Habitat development environments without having to modify the contents of my `habitat` source tree (like config files, keys, etc.).

## To use it...

Clone this repository into a directory alongside the [`habitat`](https://github.com/habitat-sh/habitat) and [`core-plans`](https://github.com/habitat-sh/core-plans) repos. (The Vagrantfile assumes the presence of both of these projects, as well as the existence of a `~/.hab/cache/keys` directory containing some keys to the `core` origin &mdash; more on this below.)

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

This starts up the Builder services. It usually takes a bit longer.

While that's running, if you haven't already, [download a package archive](http://nunciato-shared-files.s3.amazonaws.com/pkgs.zip) and unpack it into `./pkgs` (on your computer, not in the VM; you'll want to keep this directory around between VM instances). Vagrant will share the `./pkgs` directory into the VM at `/hab/cache/artifacts`.

When the `make` logging quiets down, you should have a running cluster. Look for the following lines in the recent output:

```
worker.1    | DEBUG:habitat_builder_worker::heartbeat: heartbeat pulsed
...
jobsrv.1    | DEBUG:habitat_builder_jobsrv::server::worker_manager: process_work, no pending jobs
```

Now, **leave that running**, and in another tab, once again, enter the VM, change to `root`, navigate to `/support`, and run `make load`:

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

There you go.

## How do I run the UI?

It depends!

If you want to _develop_ the UI, it's better to leave this VM running and set up to run the UI locally ([follow the instructions here](https://github.com/habitat-sh/habitat/tree/master/components/builder-web#builder-web) to do that, and you can skip the **Running the Builder API Service** section, since you're already doing that, assuming you've done everything above).

If you just want to _see_ the UI and use it, you can:

  * Uncomment [this line](https://github.com/cnunciato/habitat-support/blob/737c2afa32d4426bdf958c1aa1d4f83a46349aab/scripts/Procfile#L1) and [this line](https://github.com/cnunciato/habitat-support/blob/737c2afa32d4426bdf958c1aa1d4f83a46349aab/Vagrantfile#L15)
  * Stop the running Builder service (Ctrl-C should do it)
  * Exit the VM
  * Run `vagrant reload` to pick up the forwarding of port 3000
  * Follow the instructions above to SSH back into the VM &mdash; only this time, since you've already run `make` and compiled everything, just run `make run` to get the services running again.

In either case, you should be able to browse to the UI at http://localhost:3000/#/sign-in.

## Stuck?

I'm `@cnunciato` in the [Habitat Slack](http://slack.habitat.sh). Hit me up!
