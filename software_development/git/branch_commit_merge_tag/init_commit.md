# **[5 simple tips and tricks for writing unit tests in #golang](https://medium.com/@matryer/5-simple-tips-and-tricks-for-writing-unit-tests-in-golang-619653f90742#.mjytgulbg)**

**[Back to Research List](../../../../repsys/research/research_list.md)**\
**[Back to Current Status](../../../../repsys/development/status/weekly/current_status.md)**\
**[Back to Main](../../../../repsys/README.md)**

## Create a github repo

Call the repo mock_interfaces and clone it.

```bash
pushd .
cd ~/src/go/tutorials/unit_tests/test_tips/go_interfaces
git clone git@github.com:brentgroves/mock_interfaces.git
Cloning into 'vin1'...
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 4 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (4/4), done.
cd vin1
```

## Create the Go project and **[initialize a module](https://go.dev/ref/mod#go-mod-init)**

If you publish a module, this must be a path from which your module can be downloaded by Go tools. That would be your code's repository.

For more on naming your module with a module path, see Managing dependencies.

```bash
pushd .
cd ~/src/go/tutorials/unit_tests/test_tips/go_interfaces/mock_interfaces
# Run go mod init {module name} to create a go.mod file for the current directory. For example go mod init github.com/brutella/dnssd 

go mod init github.com/brentgroves/mock_interfaces
go: creating new go.mod: module github.com/brentgroves/go_test_tips

# Add module to go.work so vscode can find it
cd ~/src/go
go work use ./tutorials/unit_tests/test_tips/go_interfaces/mock_interfaces
code go.work 
dirs -v
pushd +x
git add -A
git commit -a -m "go_test_tips:repo creation"
git push origin main   

```

The go mod init command creates a go.mod file to track your code's dependencies. So far, the file includes only the name of your module and the Go version your code supports. But as you add dependencies, the go.mod file will list the versions your code depends on. This keeps builds reproducible and gives you direct control over which module versions to use.

## **[Create feature branch for module](./new_branch.md)**

## Verify you are on a branch instead of main

```bash
pushd .
cd ~/src/go/tutorials/unit_tests/test_tips/go_interfaces/mock_interfaces

git branch
  main
* add_test
```

Test-driven development is a great way to keep the quality of your code high, while protecting yourself from regression and proving to yourself and others that your code does what it is supposed to.

Here are five tips and tricks that can improve your tests.

## 5. Mock things using Go code

If you need to mock something that your code relies on in order to properly test it, chances are it is a good candidate for an interface. Even if you’re relying on an external package that you cannot change, your code can still take an interface that the external types will satisfy.

After a few years of writing mocks, I have finally found the perfect way of mocking interfaces, and I made a tool write the code for us without us having to add any dependencies to our project: **[Check out Moq](https://medium.com/@matryer/meet-moq-easily-mock-interfaces-in-go-476444187d10)**.

Let’s say we’re importing this external package:

```go
package mailman
import “net/mail”
type MailMan struct{}
func (m *MailMan) Send(subject, body string, to ...*mail.Address) {
  // some code
}
func New() *MailMan {
  return &MailMan{}
}
```

If the code we’re testing takes a `MailMan` object, the only way our test code can call it is by providing an actual `MailMan` instance.

```go
func SendWelcomeEmail(m *MailMan, to ...*mail.Address) {...}
```

This means that whenever we run our tests, a real email could be sent. Imagine if we’ve implemented the on save feature from above. We’d quickly annoy our test users or run up big service bills.

An alternative is to add this simple interface to your code:

```go
type EmailSender interface{
  Send(subject, body string, to ...*mail.Address)
}
```

Of course, the `MailMan` already satisfies this interface since we took the `Send` method signature from him in the first place — so we can still pass in `MailMan` objects as before.

But now we can write a test email sender:

```go
```

## **[Commit, test, merge, and publish new feature in vin1 module](./commit_test_merge_tag_publish.md)**

## **[Create branch for main module](./new_branch.md)**

update main to use new version of vin1 module.

```bash
pushd .
cd ~/src/go/tutorials/oop/vin_main

# go get github.com/brentgroves/vin1@v0.x.0
go get github.com/brentgroves/vin1@v0.6.0
go: downloading github.com/brentgroves/vin1 v0.3.0
go: upgraded github.com/brentgroves/vin1 v0.2.0 => v0.3.0
```

## Verify go.mod was updated to use the new version of the module

```bash
pushd .
cd ~/src/go/tutorials/oop/vin_main
code go.mod
go run .
```

### 4. Update main_test.go

```go
func TestVIN_EU_SmallManufacturer_Polymorphism(t *testing.T) {

 // slice of vin or vinEU types that implement VIN interface
 var testVINs []vin.VIN
 testVIN, _ := vin.NewEUVIN(euSmallVIN)
 // now there is no need to cast!
 testVINs = append(testVINs, testVIN)

 for _, vin := range testVINs {
  manufacturer := vin.Manufacturer()
  if manufacturer != "W09123" {
   t.Errorf("unexpected manufacturer %s for VIN %s", manufacturer, testVIN)
  }
 }
}
```

## Update main.go

```go
func main() {
 // Set properties of the predefined Logger, including
 // the log entry prefix and a flag to disable printing
 // the time, source file, and line number.
 log.SetPrefix("vin_main: ")
 log.SetFlags(0)

 const (
  validVIN   = "W0L000051T2123456"
  invalidVIN = "W0"
  euSmallVIN = "W09000051T2123456"
 )

 // slice of vin or vinEU types that implement VIN interface
 var testVINs []vin.VIN
 testVIN, _ := vin.NewEUVIN(euSmallVIN)
 // now there is no need to cast!
 testVINs = append(testVINs, testVIN)

 for _, vin := range testVINs {
  manufacturer := vin.Manufacturer()
  if manufacturer != "W09123" {
   log.Printf("unexpected manufacturer %s for VIN %s", manufacturer, testVIN)
  }
  fmt.Println(manufacturer)

 }

}
```

## **[Commit, test, merge, and publish new feature in main module](./commit_test_merge_tag_publish.md)**

MSC glove machine: 172.20.89.24
