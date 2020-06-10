TEMPLATE = aux

TS_FILE = $$OUT_PWD/omp-info-pro.ts
EE_QM = $$OUT_PWD/omp-info-pro_eng_en.qm

ts.commands += lupdate $$IN_PWD/.. -ts $$TS_FILE
ts.CONFIG += no_check_exist no_link
ts.output = $$TS_FILE
ts.input = .

ts_install.files = $$TS_FILE
ts_install.path = /usr/share/translations/source
ts_install.CONFIG += no_check_exist

engineering_english.path = /usr/share/omp-info-pro/translations
engineering_english.files = $$EE_QM
engineering_english.commands += lrelease -idbased $$TS_FILE -qm $$EE_QM
engineering_english.CONFIG += no_check_exist
engineering_english.depends = ts
engineering_english.input = $$TS_FILE
engineering_english.output = $$EE_QM


TRANSLATIONS = \
    omp-info-pro-ru.ts \
    omp-info-pro-tt.ts

for(t, TRANSLATIONS) {
    TRANSLATIONS_IN  += $${_PRO_FILE_PWD_}/$$t
}

qm.files = $$replace(TRANSLATIONS_IN, \.ts, .qm)
qm.path = /usr/share/omp-info-pro/translations
qm.CONFIG += no_check_exist
qm.commands += lupdate -noobsolete $$IN_PWD/.. -ts $$TS_FILE $$TRANSLATIONS_IN \
    && lrelease -idbased $$TRANSLATIONS_IN


QMAKE_EXTRA_TARGETS += ts qm engineering_english
INSTALLS += qm engineering_english ts_install

OTHER_FILES += *.ts
