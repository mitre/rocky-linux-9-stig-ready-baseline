control 'SV-257825' do
  title 'Rocky Linux 9 does not require Red Hat Subscription Manager.'
  desc 'Rocky Linux uses its own package repositories and does not use Red Hat Subscription Manager to register systems or grant subscription entitlements.'
  desc 'check', 'This control is Not Applicable to Rocky Linux 9 because Rocky Linux does not use Red Hat Subscription Manager.'
  desc 'fix', 'No action is required on Rocky Linux 9.'
  impact 0.5
  tag check_id: 'C-61566r1044887_chk'
  tag severity: 'medium'
  tag gid: 'V-257825'
  tag rid: 'SV-257825r1044888_rule'
  tag stig_id: 'RHEL-09-215010'
  tag gtitle: 'SRG-OS-000366-GPOS-00153'
  tag fix_id: 'F-61490r925461_fix'
  tag 'documentable'
  tag cci: ['CCI-001749', 'CCI-003992']
  tag nist: ['CM-5 (3)', 'CM-14']
  tag 'host'
  tag 'container'

  only_if('This control is Not Applicable on Rocky Linux because it does not use Red Hat Subscription Manager.', impact: 0.0) do
    os.name != 'rocky'
  end

  describe package('subscription-manager') do
    it { should be_installed }
  end
end
