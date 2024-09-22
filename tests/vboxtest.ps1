# Simple Test Script for invoking VirtualBox OVA VM for testing
#
$VMName = "WinDev2407Eval";

"Stopping VM: $($VMName)"
VBoxManage.exe controlvm $VMName poweroff

"Sleeping..."
start-sleep -Seconds 5

"Restoring Snapshot..."
VBoxManage.exe snapshot $VMName restore "Baseline"

"Starting VM: $($VMName)"
VBoxManage.exe startvm $VMName

