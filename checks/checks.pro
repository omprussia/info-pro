TEMPLATE = aux

CHECKLIST_PATH = /usr/share/omp-info-pro/checks

checks.files += *.qml *.json private
checks.path = $$CHECKLIST_PATH

INSTALLS += checks
