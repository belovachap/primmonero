// Kopirajto 2017 Chapman Shoop
// Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

#include "uritests.h"
#include "../guiutil.h"
#include "../walletmodel.h"

#include <QUrl>

void URITests::uriTests()
{
    SendCoinsRecipient rv;
    QUrl uri;
    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?req-dontexist="));
    QVERIFY(!GUIUtil::analizasPrimmoneraURI(uri, &rv));

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?dontexist="));
    QVERIFY(GUIUtil::analizasPrimmoneraURI(uri, &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.label == QString());
    QVERIFY(rv.amount == 0);

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?label=Wikipedia Example Address"));
    QVERIFY(GUIUtil::analizasPrimmoneraURI(uri, &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.label == QString("Wikipedia Example Address"));
    QVERIFY(rv.amount == 0);

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?amount=0.001"));
    QVERIFY(GUIUtil::analizasPrimmoneraURI(uri, &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.label == QString());
    QVERIFY(rv.amount == 100000);

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?amount=1.001"));
    QVERIFY(GUIUtil::analizasPrimmoneraURI(uri, &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.label == QString());
    QVERIFY(rv.amount == 100100000);

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?amount=100&label=Wikipedia Example"));
    QVERIFY(GUIUtil::analizasPrimmoneraURI(uri, &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.amount == 10000000000LL);
    QVERIFY(rv.label == QString("Wikipedia Example"));

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?message=Wikipedia Example Address"));
    QVERIFY(GUIUtil::analizasPrimmoneraURI(uri, &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.label == QString());

    QVERIFY(GUIUtil::analizasPrimmoneraURI("primmonero://ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?message=Wikipedia Example Address", &rv));
    QVERIFY(rv.address == QString("ANhfts45orgB98fj9W8JvqhhENYmnWEhKb"));
    QVERIFY(rv.label == QString());

    // We currently don't implement the message parameter (ok, yea, we break spec...)
    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?req-message=Wikipedia Example Address"));
    QVERIFY(!GUIUtil::analizasPrimmoneraURI(uri, &rv));

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?amount=1,000&label=Wikipedia Example"));
    QVERIFY(!GUIUtil::analizasPrimmoneraURI(uri, &rv));

    uri.setUrl(QString("primmonero:ANhfts45orgB98fj9W8JvqhhENYmnWEhKb?amount=1,000.0&label=Wikipedia Example"));
    QVERIFY(!GUIUtil::analizasPrimmoneraURI(uri, &rv));
}
