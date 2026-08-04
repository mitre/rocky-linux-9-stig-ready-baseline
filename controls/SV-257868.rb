control 'SV-257868' do
  title 'Rocky Linux 9 must mount /tmp with the nosuid option.'
  desc 'The "nosuid" mount option causes the system to not execute "setuid" and "setgid" files with owner privileges. This option must be used for mounting any file system not containing approved "setuid" and "setguid" files. Executing files from untrusted file systems increases the opportunity for nonprivileged users to attain unauthorized administrative access.'
  desc 'check', 'Verify "/tmp" is mounted with the "nosuid" option:

$ mount | grep /tmp

/dev/mapper/rhel-tmp on /tmp type xfs (rw,nodev,nosuid,noexec,seclabel)

If the "/tmp" file system is mounted without the "nosuid" option, this is a finding.'
  desc 'fix', 'Modify "/etc/fstab" to use the "nosuid" option on the "/tmp" directory.'
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000368-GPOS-00154'
  tag gid: 'V-257868'
  tag rid: 'SV-257868r958804_rule'
  tag stig_id: 'RHEL-09-231135'
  tag fix_id: 'F-61533r925590_fix'
  tag cci: ['CCI-001764']
  tag nist: ['CM-7 (2)']
  tag 'host'

  only_if('This control is Not Applicable to containers', impact: 0.0) {
    !%w[docker podman kubepods lxc].include?(virtualization.system)
  }

  path = '/tmp'
  option = 'nosuid'
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
