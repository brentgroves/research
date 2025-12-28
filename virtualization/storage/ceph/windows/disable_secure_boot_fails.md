# disabling secure boot windows fails with work account but succeeds with personal account

A device fails to disable Secure Boot when logged in with a work account because corporate security policies prevent unauthorized changes to the boot process. When you log in with your work account on a corporate-managed machine, it is likely enrolled in a Mobile Device Management (MDM) service, such as Microsoft Intune, or is joined to Microsoft Entra ID (formerly Azure Active Directory)

These services apply strict compliance policies that require security features like Secure Boot to remain enabled. When you use your personal account, these policies are not enforced, so the changes succeed.
