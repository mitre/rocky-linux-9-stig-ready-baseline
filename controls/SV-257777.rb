control 'SV-257777' do
  title 'Rocky Linux 9 must be a vendor-supported release.'
  desc 'An operating system release is considered "supported" if Rocky Linux continues to provide security patches for the product. With an unsupported release, it will not be possible to resolve security issues discovered in the system software.

Rocky Linux 9 minor releases are supported until the next minor release is available, except for the final 9.10 release, which is supported through 31 May 2032. Refer to Rocky Linux release-version policy for the current support schedule.'
  desc 'check', 'Verify the installed Rocky Linux 9 release is vendor supported with the following command:

$ cat /etc/redhat-release

Rocky Linux release 9.8 (Blue Onyx)

If the installed version of Rocky Linux 9 is not supported, this is a finding.'
  desc 'fix', 'Upgrade to a supported version of Rocky Linux 9.'
  impact 0.7
  tag severity: 'high'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-257777'
  tag rid: 'SV-257777r1155676_rule'
  tag stig_id: 'RHEL-09-211010'
  tag fix_id: 'F-61442r925317_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']
  tag 'host'
  tag 'container'

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
