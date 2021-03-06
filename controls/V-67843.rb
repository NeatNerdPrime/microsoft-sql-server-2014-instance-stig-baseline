control 'V-67843' do
  title "SQL Server must have the Data Quality Services software component
  removed if it is unused."
  desc "Information systems are capable of providing a wide variety of
  functions and services. Some of the functions and services, provided by default
  or selected for installation by an administrator, may not be necessary to
  support essential organizational operations (e.g., key missions, functions).

      Applications must adhere to the principles of least functionality by
  providing only essential capabilities.  Unused and unnecessary SQL Server
  components increase the number of available attack vectors.  By minimizing the
  services and applications installed on the system, the number of potential
  vulnerabilities is reduced.

      The Data Quality Services software component must be removed from SQL
  Server if it is unused.
  "
  impact 0.5
  tag "gtitle": 'SRG-APP-000141-DB-000091'
  tag "gid": 'V-67843'
  tag "rid": 'SV-82333r1_rule'
  tag "stig_id": 'SQL4-00-016835'
  tag "fix_id": 'F-73959r1_fix'
  tag "cci": ['CCI-000381']
  tag "nist": ['CM-7 a', 'Rev_4']
  tag "false_negatives": nil
  tag "false_positives": nil
  tag "documentable": false
  tag "mitigations": nil
  tag "severity_override_guidance": false
  tag "potential_impacts": nil
  tag "third_party_tools": nil
  tag "mitigation_controls": nil
  tag "responsibility": nil
  tag "ia_controls": nil
  tag "check": "If the Data Quality Services feature is used and satisfies
  organizational requirements, this is not a finding.

  Run the query:
  SELECT * FROM sys.databases WHERE name in ('DQS_MAIN', 'DQS_PROJECTS',
  'DQS_STAGING_DATA');

  If any rows are returned, this is a finding.

  In Windows Server 2008 R2 or lower, click on the Start button.  In the Start
  menu, navigate to All Programs >> Microsoft SQL Server 2014.

  If the \"Data Quality Services\" folder exists and contains the Data Quality
  Server Installer program, this is a finding.

  In Windows Server 2012 or higher, click on the Start button.  In the Start
  menu, navigate to Apps >> Microsoft SQL Server 2014.

  If the Data Quality Server Installer program is listed, this is a finding.

  In Windows Explorer, navigate to <drive where SQL Server is
  installed>:\\Program Files\\Microsoft SQL Server\\MSSQL12.<Instance
  name>\\MSSQL\\Binn\\

  If this contains the file DQSInstaller.exe, this is a finding."
  tag "fix": "Either using the Start menu or via the command \"control.exe\",
  open the Windows Control Panel.  Open Programs and Features.  Double-click on
  Microsoft SQL Server 2014.  In the dialog box that appears, select Remove.
  Wait for the Remove wizard to appear.

  Select the relevant SQL Server instance; click Next.

  Select Data Quality Services; click Next.

  Follow the remaining prompts, to remove Data Quality Services from SQL Server.

  Then run the following script:
  USE master;
  GO
  DROP DATABASE DQS_STAGING;
  GO
  DROP DATABASE DQS_PROJECTS;
  GO
  DROP DATABASE DQS_MAIN;
  GO

  Restart the server."

  query = %(
  SELECT name FROM sys.databases WHERE name in ('DQS_MAIN', 'DQS_PROJECTS', 'DQS_STAGING_DATA');

  )

  sql_session = mssql_session(user: attribute('user'),
                              password: attribute('password'),
                              host: attribute('host'),
                              instance: attribute('instance'),
                              port: attribute('port'),
                              db_name: attribute('db_name'))

  data_quality_services_used = attribute('data_quality_services_used')

  describe.one do
    describe 'Master Data Services is in use' do
      subject { data_quality_services_used }
      it { should be true }
    end

    describe 'List if data quality services is used' do
      subject { sql_session.query(query).column('name') }
      it { should be_empty }
    end
  end

  describe.one do
    describe 'Master Data Services is in use' do
      subject { data_quality_services_used }
      it { should be true }
    end

    describe file('C:\\Program Files\\Microsoft SQL Server\\MSSQL12.MSSQLSERVER\\MSSQL\\Binn\\DQSInstaller.exe') do
      it { should_not exist }
    end
  end
end
