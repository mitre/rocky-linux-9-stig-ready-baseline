# This profile overlays the RHEL 9 STIG baseline with Rocky-specific executable behavior.
include_controls 'redhat-enterprise-linux-9-stig-baseline' do
  # SV-257777: Rocky minor-release support dates replace the RHEL lifecycle check.
  control 'SV-257777' do
    release = os.release

    # Rocky supports only the current minor release before the final 9.10
    # maintenance release. Dates are from Rocky's release-version policy:
    # https://wiki.rockylinux.org/rocky/version/
    ROCKY_9_MINOR_EOL = {
      /^9\.0/ => 'November 26, 2022',
      /^9\.1/ => 'May 16, 2023',
      /^9\.2/ => 'November 20, 2023',
      /^9\.3/ => 'May 9, 2024',
      /^9\.4/ => 'November 19, 2024',
      /^9\.5/ => 'June 4, 2025',
      /^9\.6/ => 'December 1, 2025',
      /^9\.7/ => 'May 28, 2026',
      /^9\.8/ => 'November 30, 2026'
    }.find { |k, _v| k.match(release) }&.last

    describe "The release \"#{release}\"" do
      if ROCKY_9_MINOR_EOL.nil?
        it 'is a supported release' do
          expect(ROCKY_9_MINOR_EOL).not_to be_nil, "Rocky Linux release '#{release}' has no specified support window"
        end
      else
        it 'is still within the support window' do
          expect(Date.today).to be <= Date.parse(ROCKY_9_MINOR_EOL)
        end
      end
    end
  end

  # SV-257819: Rewritten for the Rocky package-signing key file, label, and fingerprint.
  control 'SV-257819' do
    rpm_gpg_file = input('rpm_gpg_file')
    rpm_gpg_keys = input('rpm_gpg_keys')

    describe file(rpm_gpg_file) do
      it { should exist }
    end
    rpm_gpg_keys.each do |k, v|
      describe command('rpm -q --queryformat "%{SUMMARY}\\n" gpg-pubkey') do
        its('stdout') { should include k.to_s }
      end
      next unless file(rpm_gpg_file).exist?

      describe "The fingerprint for #{k}" do
        subject { command("gpg -q --keyid-format short --with-fingerprint #{rpm_gpg_file}").stdout.gsub(/\s+/, '') }

        it 'matches the Rocky Linux package-signing key' do
          expect(subject).to include(v.gsub(/\s+/, ''))
        end
      end
    end
  end

  # SV-257825: Rocky does not use Red Hat Subscription Manager, so this control is N/A.
  control 'SV-257825' do
    only_if('This control is Not Applicable on Rocky Linux because it does not use Red Hat Subscription Manager.', impact: 0.0) do
      os.name != 'rocky'
    end

    describe package('subscription-manager') do
      it { should be_installed }
    end
  end
end
