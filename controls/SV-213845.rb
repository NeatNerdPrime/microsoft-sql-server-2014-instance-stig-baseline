control 'SV-213845' do
  title 'SQL Server must have the Management Tools software component removed if it is unused.'
  desc 'Information systems are capable of providing a wide variety of functions and services. Some of the functions and services, provided by default or selected for installation by an administrator, may not be necessary to support essential organizational operations (e.g., key missions, functions).

Applications must adhere to the principles of least functionality by providing only essential capabilities.  Unused and unnecessary SQL Server components increase the number of available attack vectors.  By minimizing the services and applications installed on the system, the number of potential vulnerabilities is reduced.

Management Tools is an indispensable software component on any server running the SQL Server DBMS, if the database administrator logs on to the Windows server to do his/her work.  However, it is also possible to use the management tools on a separate machine and still connect to SQL Server.  If this approach is used and DBAs never need to use the Management Tools directly on the server, then the Management Tools software component must be removed from the server.'
  desc 'check', 'If the SQL Server Management Tools are used and satisfy organizational requirements, this is not a finding.

In Windows Server 2008 R2 or lower, click on the Start button.  In the Start menu, navigate to All Programs >> Microsoft SQL Server 2014.

If the SQL Server Management Studio is listed, this is a finding.

In Windows Server 2012 or higher, click on the Start button.  In the Start menu, navigate to Apps >> Microsoft SQL Server 2014.

If the SQL Server Management Studio is listed, this is a finding.'
  desc 'fix', 'Either using the Start menu or via the command "control.exe", open the Windows Control Panel.  Open Programs and Features.  Double-click on Microsoft SQL Server 2014.  In the dialog box that appears, select Remove.  Wait for the Remove wizard to appear.

Select the relevant SQL Server instance; click Next.

Select Management Tools - Basic and Management Tools - Complete; click Next.

Follow the remaining prompts, to remove Management Tools from SQL Server.'
  impact 0.5
  ref 'DPMS Target MS SQL Server 2014 Instance'
  tag check_id: 'C-15064r312886_chk'
  tag severity: 'medium'
  tag gid: 'V-213845'
  tag rid: 'SV-213845r960963_rule'
  tag stig_id: 'SQL4-00-016850'
  tag gtitle: 'SRG-APP-000141-DB-000091'
  tag fix_id: 'F-15062r312887_fix'
  tag 'documentable'
  tag legacy: ['SV-82337', 'V-67847']
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  sql_mgmt_tools_used = input('sql_mgmt_tools_used')

  describe.one do
    describe 'SQL server_management tools is in use' do
      subject { sql_mgmt_tools_used }
      it { should be true }
    end
    describe file('C:\\Program Files (x86)\\Microsoft SQL Server\\120\\Tools\\Binn\\ManagementStudio\\Ssms.exe') do
      it { should_not exist }
    end
  end
end
