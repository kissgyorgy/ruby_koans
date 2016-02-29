# -*- coding: utf-8 -*-
import pytest


class Proxy(object):
    def __init__(self, obj):
        self._obj = obj
        self._messages = []

    def __getattr__(self, name):
        self._messages.append(name)
        return getattr(self._obj, name)

    def __setattr__(self, name, value):
        if name.startswith('_'):
            object.__setattr__(self, name, value)
        else:
            self._messages.append(name)
            setattr(self._obj, name, value)

    @property
    def messages(self):
        return self._messages

    def is_called(self, name):
        return name in self._messages

    def number_of_times_called(self, name):
        return self._messages.count(name)


class TestAboutProxyObjectProject:
    def test_proxy_method_returns_wrapped_object(self):
        tv = Proxy(Television())
        assert isinstance(tv, Proxy)

    def test_tv_methods_still_perform_their_function(self):
        tv = Proxy(Television())

        tv.channel = 10
        tv.power()

        assert tv.channel == 10
        assert tv.is_on()

    def test_proxy_records_messages_sent_to_tv(self):
        tv = Proxy(Television())

        tv.power
        tv.channel = 10

        assert tv.messages == ['power', 'channel']

    def test_proxy_handles_invalid_messages(self):
        tv = Proxy(Television())

        with pytest.raises(AttributeError):
            tv.no_such_method()

    def test_proxy_reports_methods_have_been_called(self):
        tv = Proxy(Television())

        tv.power()
        tv.power()

        assert tv.is_called('power')
        assert not tv.is_called('channel')

    def test_proxy_counts_method_calls(self):
        tv = Proxy(Television())

        tv.power()
        tv.channel = 48
        tv.power()

        assert tv.number_of_times_called('power') == 2
        assert tv.number_of_times_called('channel') == 1
        assert tv.number_of_times_called('is_on') == 0

    def test_proxy_can_record_more_than_just_tv_objects(self):
        proxy = Proxy("Code Mash 2009")

        # str in Python is immutable, there is no way to change it in place like in Ruby
        proxy._obj = proxy.upper()
        result = proxy.split()

        assert result == ['CODE', 'MASH', '2009']
        assert proxy.messages == ['upper', 'split']


class Television(object):
    def __init__(self):
        self._channel = None
        self._power = 'OFF'

    @property
    def channel(self):
        return self._channel

    @channel.setter
    def channel(self, value):
        self._channel = value

    def power(self):
        if self._power == 'ON':
            self._power = 'OFF'
        else:
            self._power = 'ON'

    def is_on(self):
        return self._power == 'ON'


class TestTelevisionTest:
    def test_it_turns_on(self):
        tv = Television()

        tv.power()
        assert tv.is_on

    def test_it_also_turns_off(self):
        tv = Television()

        tv.power()
        tv.power()

        assert not tv.is_on()

    def test_edge_case_on_off(self):
        tv = Television()

        tv.power()
        tv.power()
        tv.power()

        assert tv.is_on()

        tv.power()

        assert not tv.is_on()

    def test_can_set_the_channel(self):
        tv = Television()

        tv.channel = 11
        assert tv.channel == 11
