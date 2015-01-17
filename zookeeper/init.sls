{%- from 'zookeeper/settings.sls' import zk with context %}

zookeeper:
  group.present:
    - gid: {{ zk.uid }}
  user.present:
    - uid: {{ zk.uid }}
    - gid: {{ zk.uid }}

zk-directories:
  file.directory:
    - user: zookeeper
    - group: zookeeper
    - mode: 755
    - makedirs: True
    - names:
      - /var/run/zookeeper
      - /var/lib/zookeeper
      - /var/log/zookeeper

zookeeper_packages:
  pkg.installed:
    - pkgs:
      - zookeeper: {{ zk.version }}
      - zookeeperd: {{ zk.version }}
