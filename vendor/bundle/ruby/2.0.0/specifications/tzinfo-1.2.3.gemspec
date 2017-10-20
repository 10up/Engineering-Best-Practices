# -*- encoding: utf-8 -*-
# stub: tzinfo 1.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "tzinfo".freeze
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Philip Ross".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDdDCCAlygAwIBAgIBATANBgkqhkiG9w0BAQUFADBAMRIwEAYDVQQDDAlwaGls\nLnJvc3MxFTATBgoJkiaJk/IsZAEZFgVnbWFpbDETMBEGCgmSJomT8ixkARkWA2Nv\nbTAeFw0xNjEwMjAxOTMyMDZaFw0xNzEwMjAxOTMyMDZaMEAxEjAQBgNVBAMMCXBo\naWwucm9zczEVMBMGCgmSJomT8ixkARkWBWdtYWlsMRMwEQYKCZImiZPyLGQBGRYD\nY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkZzB+qfhmyY+XRvU\nu310LMTGsTkR4/8JFCMF0YeQX6ZKmLr1fKzF3At1+DlI+v0t/G2FS6Dic0V3l8MK\nJczyFh72NANOaQhAo0GHh8WkaeCf2DLL5K6YJeLpvkvp39oxzn00A4zosnzxM50f\nXrjx2HmurcJQurzafeCDj67QccaNE+5H+mcIVAJlsA1h1f5QFZ3SqQ4mf8St40pE\n6YR4ev/Eq6Hb8aUoUq30otxbeHAEHh8cdVhTNFq7sPWb0psQRF2D/+o0MLgHt8PY\nEUm49szlLsnjVXAMCHU7wH9CmDR/5Lzcrgqh3DgyI8ay6DnlSQ213eYZH/Nkn1Yz\nTcNLCQIDAQABo3kwdzAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHQ4EFgQU\nD5nzO9/MG4B6ygch/Pv6PF9Q5x8wHgYDVR0RBBcwFYETcGhpbC5yb3NzQGdtYWls\nLmNvbTAeBgNVHRIEFzAVgRNwaGlsLnJvc3NAZ21haWwuY29tMA0GCSqGSIb3DQEB\nBQUAA4IBAQBM+pMz41DnLx/Edg6cZe7JYFeXXQmVeltwDEefCa4cXxfLTsR6m7vW\naBxCCJ62qrfe2dF1d8lp5X94nAmG8FyzSH4Gt8Ul69zOLw31E5XkT2bDcBTzWwcf\nOmYp+4rBeXWVwf76baYDNrJyFBp42cuj3vQBOQ2mJcwjeBldyUFVxElq93ISpN+2\nxSO5T8UfFZWHwv9H9cGhQnInu/hpl/vFcz5LM/l1CODRITfEbNUlr6Lb4JLxm58y\nsB3eS05Xw5lTvyhTICdMJIRk5jPPk3Sv/H1G7urfugkdEqT66FO+pgBnC9o7HvXN\nE2bpXUbNbgEUfOfgi7vQ9NLDfb+3Brxl\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2017-03-25"
  s.description = "TZInfo provides daylight savings aware transformations between times in different time zones.".freeze
  s.email = "phil.ross@gmail.com".freeze
  s.extra_rdoc_files = ["README.md".freeze, "CHANGES.md".freeze, "LICENSE".freeze]
  s.files = ["CHANGES.md".freeze, "LICENSE".freeze, "README.md".freeze]
  s.homepage = "http://tzinfo.github.io".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "TZInfo".freeze, "--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7".freeze)
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Daylight savings aware timezone library".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thread_safe>.freeze, ["~> 0.1"])
    else
      s.add_dependency(%q<thread_safe>.freeze, ["~> 0.1"])
    end
  else
    s.add_dependency(%q<thread_safe>.freeze, ["~> 0.1"])
  end
end
