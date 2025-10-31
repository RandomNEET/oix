{ opts, ... }:
{
  services.cron = {
    enable = true;
    cronFiles = opts.cron.cronFiles or [ ];
    systemCronJobs = opts.cron.systemCronJobs or [ ];
    mailto = opts.cron.mailto or null;
  };
}
