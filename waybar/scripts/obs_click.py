#!/usr/bin/python3
import obsws_python as obs


def main():
    """Main function"""
    cl = obs.ReqClient()
    cl.trigger_studio_mode_transition()


if __name__ == "__main__":
    main()
