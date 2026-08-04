control 'SV-257819' do
  title 'Rocky Linux 9 must ensure cryptographic verification of vendor software packages.'
  desc 'Cryptographic verification of vendor software packages ensures that all software packages are obtained from a valid source and protects against spoofing that could lead to installation of malware. Rocky Linux cryptographically signs its software packages, including updates, with GPG keys to verify their validity.'
  desc 'check', 'Confirm the Rocky Linux package-signing key is installed and its fingerprint matches the vendor value.

List installed GPG keys:

$ sudo rpm -q --queryformat "%{SUMMARY}\\n" gpg-pubkey | grep -i "Rocky"

Verify the Rocky Linux 9 release key file exists:

$ sudo gpg -q --keyid-format short --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-9

If the key file is missing, the Rocky Linux package-signing key is not installed, or its fingerprint does not match the organization-approved Rocky Linux signing-key fingerprint, this is a finding.'
  desc 'fix', 'Install the Rocky Linux package-signing key and verify its fingerprint against the Rocky Linux published signing-key value.

Import the Rocky Linux 9 release key into the system keyring:

$ sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-9

Use the Check Text command to confirm that the imported key is installed and has the expected fingerprint.'
  impact 0.5
  tag check_id: 'C-61560r925442_chk'
  tag severity: 'medium'
  tag gid: 'V-257819'
  tag rid: 'SV-257819r1015075_rule'
  tag stig_id: 'RHEL-09-214010'
  tag gtitle: 'SRG-OS-000366-GPOS-00153'
  tag fix_id: 'F-61484r925443_fix'
  tag 'documentable'
  tag cci: ['CCI-001749', 'CCI-003992']
  tag nist: ['CM-5 (3)', 'CM-14']
  tag 'host'
  tag 'container'

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
