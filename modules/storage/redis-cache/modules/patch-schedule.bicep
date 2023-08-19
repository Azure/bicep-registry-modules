param redisCacheName string

@description(
'''
The predefined schedule for patching redis server. The Patch Window lasts for 5 hours from the start_hour_utc.
If schedule is not specified, the update can happen at any time. See https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-administration#schedule-updates-faq
''')
param redisPatchSchedule redisPatchScheduleType[]

resource redisCacheReference 'Microsoft.Cache/redis@2022-06-01' existing = {
  name: redisCacheName
}

resource patchSchedule 'Microsoft.Cache/redis/patchSchedules@2022-06-01' = if (!empty(redisPatchSchedule)) {
  name: 'default'
  parent: redisCacheReference
  properties: {
    scheduleEntries: redisPatchSchedule
  }
}

type redisPatchScheduleType = {
  @description('The day of the week when a cache can be patched. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday.')
  dayOfWeek: string
  @description('The start hour after which cache patching can start.')
  startHourUtc: int
  @description('ISO8601 timespan specifying how much time cache patching can take.')
  maintenanceWindow: int?
}
