# Rocky Linux 9 STIG-ready InSpec Profile

This InSpec profile adapts the Red Hat Enterprise Linux 9 Security Technical Implementation Guide (RHEL9 STIG) for Rocky Linux 9. It can help programs automate Rocky Linux compliance checks against the DoD requirements represented by the source RHEL9 STIG.

- Profile Version: `2.4.0`
- Source guidance: Red Hat Enterprise Linux 9 Security Technical Implementation Guide v2r7

This profile was developed to reduce the time it takes to perform a security checks based upon the STIG Guidance from the Defense Information Systems Agency (DISA) in partnership between the DISA Services Directorate (SD) and the DISA Risk Management Executive (RME) office.

The results of a profile run will provide information needed to support an Authority to Operate (ATO) decision for the applicable technology.

This profile uses the [InSpec](https://github.com/inspec/inspec) open-source compliance validation language to support automation of the required compliance, security and policy testing for Assessment and Authorization (A&A), Authority to Operate (ATO), and Continuous Authority to Operate (cATO) processes.

Table of Contents
=================

- [Rocky Linux 9 STIG-ready InSpec Profile](#rocky-linux-9-stig-ready-inspec-profile)
  - [Source guidance](#source-guidance)
    - [Rocky Linux Tailoring](#rocky-linux-tailoring)
- [Getting Started and Intended Usage](#getting-started-and-intended-usage)
  - [Intended Usage - main vs releases](#intended-usage---main-vs-releases)
  - [Environment Aware Testing](#environment-aware-testing)
  - [Tailoring to Your Environment](#tailoring-to-your-environment)
- [Running the Profile](#running-the-profile)
  - [(connected) Running the Profile Directly](#connected-running-the-profile-directly)
  - [(disconnected) Running the profile from a local archive copy](#disconnected-running-the-profile-from-a-local-archive-copy)
  - [Different Run Options](#different-run-options)
- [Using Heimdall for Viewing Test Results and Exporting for Checklist and eMASS](#using-heimdall-for-viewing-test-results-and-exporting-for-checklist-and-emass)

## Source Guidance

The DISA RME and DISA SD Office, along with their vendor partners, create and maintain a set of Security Technical Implementation Guides for applications, computer systems and networks connected to the Department of Defense (DoD). These guidelines are the primary security standards used by the DoD agencies. In addition to defining security guidelines, the STIGs also stipulate how security training should proceed and when security checks should occur. Organizations must stay compliant with these guidelines or they risk having their access to the DoD terminated.

The RHEL9 STIG (see public.cyber.mil/stigs/) is the source compliance guide adapted by this profile for Rocky Linux 9. DISA does not publish a separate Rocky Linux 9 STIG.

The requirements associated with the RHEL9 STIG are derived from the [Security Requirements Guides](https://csrc.nist.gov/glossary/term/security_requirements_guide) and align to the [National Institute of Standards and Technology](https://www.nist.gov/) (NIST) [Special Publication (SP) 800-53](https://csrc.nist.gov/Projects/risk-management/sp800-53-controls/release-search#!/800-53) Security Controls, [DoD Control Correlation Identifier](https://public.cyber.mil/stigs/cci/) and related standards.

The source RHEL9 STIG checks provide technical implementation validation for the defined DoD requirements. This profile adapts those checks for Rocky Linux 9.

### Rocky Linux Tailoring

This profile retains the source RHEL9 STIG control identifiers, CCIs, NIST mappings, and severity tags for traceability. It changes control titles, rationale, check text, and remediation directions only where RHEL-specific behavior would be inaccurate for Rocky Linux, such as release support policy, package repositories, signing keys, and Red Hat Subscription Manager applicability. These changes do not alter the underlying DoD security requirement.

RHEL-specific Subscription Manager validation is Not Applicable on Rocky Linux because Rocky does not use Red Hat subscription entitlements. Rocky lifecycle and signing-key values are vendor-specific and must be revalidated when Rocky publishes a new release or signing key. This is tailored guidance for Rocky Linux 9, not official DISA Rocky Linux STIG content; organizations should retain their tailoring rationale as assessment evidence.

### Source STIG

- Red Hat Enterprise Linux 9 Security Technical Implementation Guide v2r7

### Current Profile Statistics

The profile is tested against a vanilla Rocky Linux container and against both vanilla and Ansible-hardened Rocky Linux virtual machines. The container scan is a smoke test; the virtual-machine workflow is the authoritative hardened-target test.

Further pipelines may be employed to test different hardening content sources (e.g., Ansible code sourced directly from DISA or Red Hat).

# Getting Started and Intended Usage

1. It is intended and recommended that InSpec and the profile be run from a **"runner"** host, either from source or a local archieve - [Running the Profile](#running-the-profile) - (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target [ remotely over **ssh**].

2. **For the best security of the runner, always install on the runner the _latest version_ of InSpec and supporting Ruby language components.**

3. The latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

4. Always use the latest version of the `released profile` (see below) on your system.

## Intended Usage - `main` vs `releases`

1. The latest `released` version of the profile is intended for use in A&A testing, as well as providing formal results to Authorizing Officials and IAMs. Please use the `released` versions of the profile in these types of workflows.

2. The `main` branch is a development branch that will become the next release of the profile. The `main` branch is intended for use in _developing and testing_ merge requests for the next release of the profile, and _is not intended_ be used for formal and ongoing testing on systems.

## Environment Aware Testing

This profile is `container aware` and can determine when it runs inside or outside a `docker container`, running only the tests appropriate to the environment. The tests are tagged as `host` or `host, container`.

All the profile's tests (`controls`) apply to the `host` but many of the controls are `Not Applicable` when running inside a `docker container` (such as, for example, controls that test the system's GUI). When running inside a `docker container`, the tests that only applicable to the host will be marked as `Not Applicable` automatically.

## Tailoring to Your Environment

### Profile Inputs (see `inspec.yml` file)

This profile uses InSpec Inputs to make the tests more flexible. You are able to provide inputs at runtime either via the cli or via YAML files to help the profile work best in your deployment.

#### **_Do not change the inputs in the `inspec.yml` file_**

The `inputs` configured in the `inspec.yml` file are **profile definition and defaults for the profile** and not for the user. InSpec provides two ways to adjust the profiles inputs at run-time that do not require modifiying `inspec.yml` itself. This is because automated profiles like this one are frequently run from a script, inside a pipeline or some kind of task scheduler. Such automation usually works by running the profile directly from its source (i.e. this repository), which means the runner will not have access to the `inspec.yml`.

To tailor the tested values for your deployment or organizationally defined values, **_you may update the inputs_**.

#### Update Profile Inputs from the CLI or Local File

1. Via the cli with the `--input` flag
2. Pass them in a YAML file with the `--input-file` flag.

More information about InSpec inputs can be found in the [InSpec Inputs Documentation](https://docs.chef.io/inspec/inputs/).

#### See the `inspec.yml` file for full list of available inputs

Example Inputs

```yaml
  TODO
```

# Running the Profile

## (connected) Running the Profile Directly

```
inspec exec https://github.com/mitre/rocky-linux-9-stig-ready-baseline/archive/main.tar.gz --input-file=<your_inputs_file.yml> -t ssh://<hostname>:<port> --sudo --reporter=cli json:<your_results_file.json>
```

## (disconnected) Running the profile from a local archive copy

If your runner is not always expected to have direct access to the profile's hosted location, use the following steps to create an archive bundle of this overlay and all of its dependent tests:

(Git is required to clone the InSpec profile using the instructions below. Git can be downloaded from the [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) site.)

When the **"runner"** host uses this profile overlay for the first time, follow these steps:

```
mkdir profiles
cd profiles
git clone https://github.com/mitre/rocky-linux-9-stig-ready-baseline.git
inspec archive rocky-linux-9-stig-ready-baseline
<sneakerNet your archive>
inspec exec <name of generated archive> --input-file=<your_inputs_file.yml> -t ssh://<hostname>:<port> --sudo --reporter=cli json:<your_results_file.json>
```

For every successive run, follow these steps to always have the latest version of this overlay and dependent profiles:

1. Delete and recreate your archive as shown above
2. Update your archive with the following steps

```
cd rocky-linux-9-stig-ready-baseline
git pull
cd ..
inspec archive rocky-linux-9-stig-ready-baseline
```

## Different Run Options

[Full exec options](https://docs.chef.io/inspec/cli/#options-3)

# Using Heimdall for Viewing Test Results and Exporting for Checklist and eMASS

The JSON results output file can be loaded into **[Heimdall](https://heimdall-lite.mitre.org/)** for a user-interactive, graphical view of the profile scan results. Heimdall-Lite is a `browser only` viewer that allows you to easily view your results directly and locally rendered in your browser.

It can also **_export your results into a DISA Checklist (CKL) file_** for easily upload into eMass using the `Heimdall Export` function.

Depending on your enviroment, you can also use the [SAF CLI](https://saf-cli.mitre.org) to run a local docker instance of heimdall-lite via the `saf view:heimdall` command.

The JSON results file may also be loaded into a **[full Heimdall Server](https://github.com/mitre/heimdall2)**, allowing for additional functionality such as to store and compare multiple profile runs.

You can deploy your own instances of Heimdall-Lite or Heimdall Server easily via docker, kurbernetes, or the installation packages.

# Authors

Defense Information Systems Agency (DISA) <https://www.disa.mil/>

STIG support by DISA Risk Management Team and Cyber Exchange <https://public.cyber.mil/>

MITRE Security Automation Framework Team <https://saf.mitre.org>

### NOTICE

DISA STIGs are published by DISA IASE, see: <https://iase.disa.mil/Pages/privacy_policy.aspx>
