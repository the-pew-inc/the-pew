<br>
<div>
<img src="/images/logo.png" alt="ThePew, know what your audiences want" title="ThePew, know what your audiences want" height="200px">
</div>

## PROJECT STATUS
[![Maintainability](https://api.codeclimate.com/v1/badges/610524b9bc52d96580e1/maintainability)](https://codeclimate.com/github/spaquet/the-pew/maintainability) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)

[![Version](https://img.shields.io/github/v/release/the-pew-inc/the-pew?display_name=tag)]()

## SUPPORT US
[![Open Source Helpers](https://www.codetriage.com/the-pew-inc/the-pew/badges/users.svg)](https://www.codetriage.com/the-pew-inc/the-pew)

## DESCRIPTION

As a comprehensive audience analytics platform, THEPEW enables you to understand your employees, team members, prospects, and more. By analyzing audience responses and behavior over time, you can identify patterns and trends that provide insights into their needs, expectations, feature requests, and communication gaps.

THEPEW is designed to help businesses identify trends, analyze topic evolution over time, and track geographic locations using advanced data visualization tools. These reports can be shared with stakeholders and team members, empowering businesses to make data-driven decisions that improve overall performance.

Using openAI, THEPEW provides personalized recommendations that are tailored to each participant's individual interests. Whether it's valuable insights, informative articles, or self-improvement resources, THEPEW gives back to its participants in meaningful ways that help them grow and improve.

## LICENSE
[License](../master/LICENSE.md)

## INSTALLATION
### PREREQUISITES
- ruby (version 3.2 with YJIT)
- rails (version 7.0.7.2)
- postgresql (version 15 or above)
- mailcatcher
- redis (version 6.2)
- docker (used by postgres, redis and mailcatcher)

### INSTALLING POSTGRES USING DOCKER
docker run -p 5432:5432 --name postgres-15.2-alpine -e POSTGRES_PASSWORD=mysecretpassword -d postgres:15.2-alpine

### INSTALLING REDIS USING DOCKER
docker run -p 6379:6379 --name redis-6.2-alpine -d 6.2-alpine

### INSTALLING MAILCATCHER USING DOCKER
docker run -p 1080:1080 -p 1025:1025 --name mailcatcher -d stpaquet/alpinemailcatcher

For more information you can read this medium post [https://medium.com/@spaquet/mailcatcher-to-the-rescue-4ba438dc98c2](https://medium.com/@spaquet/mailcatcher-to-the-rescue-4ba438dc98c2)

## CREDITS
Shout out to the following projects:
### Javascript:
- [chart.js](https://www.chartjs.org)
- [flowbite](https://flowbite.com)
- [Merakiui - Email Templates](https://merakiui.com/components/email-templates)
- [QR Code Styling](https://github.com/kozakdenys/qr-code-styling)
- [stimulus-autocomplete](https://github.com/afcapel/stimulus-autocomplete)
- [taggle](https://github.com/okcoker/taggle.js)
- [tailwindcss](https://tailwindcss.com)

### RubyGems: