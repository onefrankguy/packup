Packup
======

Packup is a Rake helper for building Windows installers. It helps you write simple MSI packages.

Synopsis
--------

Write a Rakefile:

    require 'packup'

    Packup.stuff 'Magic' do
      author 'Wizard'
      version '1.0.0'

      file 'src/README'   => '/docs/readme.txt'
      file 'src/wand.exe' => '/bin/wand.exe'
    end

Build a MSI and install it:

    % rake msi
    % msiexec /i wix\Magic.msi

Dependencies
------------

Packup requires the [WiX Toolset][wix] be installed, and the binaries be reachable from the PATH environment variable.

License
-------

Packup is available under an [MIT-style][mit] license.

[wix]: http://wixtoolset.org/ "The WiX toolset builds Windows installation packages from XML source code."
[mit]:  http://opensource.org/license/MIT "Open Source Initiative OSI - The MIT License"
