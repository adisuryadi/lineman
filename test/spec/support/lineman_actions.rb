module LinemanActions
  ROOT = File.join(File.dirname(__FILE__), "../../..")
  BIN= File.join(ROOT, "cli.js")

  def lineman_new
    sh <<-BASH
      mkdir -p tmp
      cd tmp
      rm -rf pants
      #{BIN} new pants --skip-install
    BASH
    lineman_link
  end

  def lineman_link
    sh <<-BASH
      cd tmp/pants
      mkdir -p node_modules
      ln -s #{ROOT} node_modules/lineman
    BASH
  end

  def lineman_build
    sh <<-BASH
      cd tmp/pants
      #{BIN} build --stack
    BASH
  end

  def lineman_tear_down
    sh 'rm -rf tmp'
  end

private

  def sh(command)
    `#{command}`.tap do |output|
      unless $?.success?
        raise <<-ERR
          Command  failed! You ran:
          #{command}

          STDOUT:
          #{output}
        ERR
      end
    end
  end
end