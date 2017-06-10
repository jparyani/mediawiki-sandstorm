@0xb2b626bd4d31c1ba;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "y88wavuqwz0p3tjcqtdt8egauq9hpnzr1s9efq1d63rwtj1w0ech",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "MediaWiki"),

    appVersion = 6,  # Increment this for every release.

    appMarketingVersion = (defaultText = "1.25.2-1"),

    actions = [
      # Define your "new document" handlers ere.
      ( title = (defaultText = "New MediaWiki"),
        nounPhrase = (defaultText = "wiki"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand,

    metadata = (
      icons = (
        appGrid = (png = (
          dpi1x = embed "app-graphics/mediawiki-128.png",
          dpi2x = embed "app-graphics/mediawiki-256.png"
        )),
        grain = (svg = ( embed "app-graphics/mediawiki-24.svg")),
        market = (png = (
          dpi1x = embed "app-graphics/mediawiki-150.png",
          dpi2x = embed "app-graphics/mediawiki-300.png"
        )),
      ),

      website = "https://www.mediawiki.org",
      codeUrl = "https://github.com/jparyani/mediawiki-sandstorm",
      license = (openSource = gpl2),
      categories = [productivity],

      author = (
        contactEmail = "jparyani@sandstorm.io",
        pgpSignature = embed "pgp-signature",
        upstreamAuthor = "MediaWiki Contributors",
      ),
      pgpKeyring = embed "pgp-keyring",

      description = (defaultText = embed "description.md"),
      shortDescription = (defaultText = "Wiki"),

      changeLog = (defaultText = embed "../mediawiki-core/HISTORY"),

      screenshots = [
        (width = 1280, height = 614, png = embed "screenshot_mediawiki_home.png"),
        (width = 1280, height = 614, png = embed "screenshot_mediawiki_config.png")
      ],
    ),
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( packagePath = "opt/app/mediawiki-core/LocalSettings.php", sourcePath = "/opt/app/LocalSettings.php" ),
      ( packagePath = "opt/app/.git", sourcePath = "/opt/app/.gitignore" ),
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf" ]
        # You probably don't want the app pulling files from these places,
        # so we hide them. Note that /dev, /var, and /tmp are implicitly
        # hidden because Sandstorm itself provides them.
      )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = ["opt/app"],
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.

  bridgeConfig = (
    viewInfo = (
      permissions = [(name = "admin")],
      roles = [(title = (defaultText = "admin"),
                permissions = [true,],
                verbPhrase = (defaultText = "can administer wiki")),
               (title = (defaultText = "viewer"),
                permissions = [false],
                verbPhrase = (defaultText = "can view any article"),
                default = true)],
    )
  ),
);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "8000", "--", "/opt/app/.sandstorm/launcher.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "HOME", value = "/var")
  ]
);
