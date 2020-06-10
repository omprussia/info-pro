Name:       omp-info-pro

Summary:    OMP Info Pro Application
Version:    0.1.0
Release:    1
Group:      Applications
License:    MIT
URL:        https://git.omprussia.ru/openmobileplatform/%{name}
Source0:    %{name}-%{version}.tar.bz2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  qt5-qttools
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils
BuildRequires:  pkgconfig(sailfishsilica) >= 0.24.15
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  sailfish-svg2png >= 0.1.4
BuildRequires:  pkgconfig(mlite5)

Requires:       sailfishsilica-qt5 >= 1.1.46
Recommends:     %{name}-l10n
Recommends:     %{name}-config

%description
Description OMP Info Pro

%package tools
Summary:   tools

%description tools
%{summary}.

%package ts-devel
Summary:   Translation source

%description ts-devel
%{summary}.

%prep
%autosetup -n %{name}-%{version}

%build
%qmake5
%make_build

%install
%make_install

%clean
rm -rf %{_builddir}/application/86x86
rm -rf %{_builddir}/application/108x108
rm -rf %{_builddir}/application/128x128
rm -rf %{_builddir}/application/256x256

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}/main.qml
%{_datadir}/%{name}/pages
%{_datadir}/%{name}/cover
%{_datadir}/%{name}/graphics
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/%{name}/translations/%{name}*.qm
%{_datadir}/%{name}/graphics
%{_datadir}/omp-info-pro/checks/private/*
%{_datadir}/omp-info-pro/checks/*.qml
%{_datadir}/omp-info-pro/checks/*.json
#%license LICENSE

%files tools
%defattr(-,root,root,-)
%{_bindir}/save-reference


%files ts-devel
%defattr(-,root,root,-)
%{_datadir}/translations/source/%{name}.ts
