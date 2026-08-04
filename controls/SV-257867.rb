control 'SV-257867' do
  title 'Rocky Linux 9 must mount /tmp with the noexec option.'
  desc 'The "noexec" mount option causes the system to not execute binary files. This option must be used for mounting any file system not containing approved binary files, as they may be incompatible. Executing files from untrusted file systems increases the opportunity for nonprivileged users to attain unauthorized administrative access.'
  desc 'check', 'Verify "/tmp" is mounted with the "noexec" option:

$ mount | grep /tmp

/dev/mapper/rhel-tmp on /tmp type xfs (rw,nodev,nosuid,noexec,seclabel)

If the "/tmp" file system is mounted without the "noexec" option, this is a finding.'
  desc 'fix', 'Modify "/etc/fstab" to use the "noexec" option on the "/tmp" directory.'
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000368-GPOS-00154'
  tag gid: 'V-257867'
  tag rid: 'SV-257867r958804_rule'
  tag stig_id: 'RHEL-09-231130'
  tag fix_id: 'F-61532r925587_fix'
  tag cci: ['CCI-001764']
  tag nist: ['CM-7 (2)']
  tag 'host'

  only_if('This control is Not Applicable to containers', impact: 0.0) {
    !%w[docker podman kubepods lxc].include?(virtualization.system)
  }

  path = '/tmp'
  option = 'noexec'
  path_mount = mount(path)
  fstab_mount = etc_fstab.where { mount_point == path }

  describe path_mount do
    it { should be_mounted }
  end

  if path_mount.mounted?
    describe path_mount do
      its('options') { should include option }
    end
  end

  describe fstab_mount do
    it { should exist }
  end

  if fstab_mount.configured?
    describe fstab_mount do
      its('mount_options.flatten') { should include option }
    end
  end
end
