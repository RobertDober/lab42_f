ExUnit.configure(exclude: [:dev, :later, :meta, :performance, :wip], timeout: 10_000_000)
ExUnit.start()

Lab42.F.SysInterface.Mock.start_link

# SPDX-License-Identifier: Apache-2.0
