package uk.ac.kcl.inf.modelling.xdsml.ide.contentassist.antlr.internal;

import java.io.InputStream;
import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.AbstractInternalContentAssistParser;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.DFA;
import uk.ac.kcl.inf.modelling.xdsml.services.HenshinXDsmlSpecificationGrammarAccess;



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalHenshinXDsmlSpecificationParser extends AbstractInternalContentAssistParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'metamodel'", "'\"'", "'step'"
    };
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_STRING=6;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_SL_COMMENT=8;
    public static final int RULE_INT=5;
    public static final int T__11=11;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int EOF=-1;

    // delegates
    // delegators


        public InternalHenshinXDsmlSpecificationParser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public InternalHenshinXDsmlSpecificationParser(TokenStream input, RecognizerSharedState state) {
            super(input, state);
             
        }
        

    public String[] getTokenNames() { return InternalHenshinXDsmlSpecificationParser.tokenNames; }
    public String getGrammarFileName() { return "InternalHenshinXDsmlSpecification.g"; }


    	private HenshinXDsmlSpecificationGrammarAccess grammarAccess;

    	public void setGrammarAccess(HenshinXDsmlSpecificationGrammarAccess grammarAccess) {
    		this.grammarAccess = grammarAccess;
    	}

    	@Override
    	protected Grammar getGrammar() {
    		return grammarAccess.getGrammar();
    	}

    	@Override
    	protected String getValueForTokenName(String tokenName) {
    		return tokenName;
    	}



    // $ANTLR start "entryRuleHenshinXDsmlSpecification"
    // InternalHenshinXDsmlSpecification.g:53:1: entryRuleHenshinXDsmlSpecification : ruleHenshinXDsmlSpecification EOF ;
    public final void entryRuleHenshinXDsmlSpecification() throws RecognitionException {
        try {
            // InternalHenshinXDsmlSpecification.g:54:1: ( ruleHenshinXDsmlSpecification EOF )
            // InternalHenshinXDsmlSpecification.g:55:1: ruleHenshinXDsmlSpecification EOF
            {
             before(grammarAccess.getHenshinXDsmlSpecificationRule()); 
            pushFollow(FOLLOW_1);
            ruleHenshinXDsmlSpecification();

            state._fsp--;

             after(grammarAccess.getHenshinXDsmlSpecificationRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleHenshinXDsmlSpecification"


    // $ANTLR start "ruleHenshinXDsmlSpecification"
    // InternalHenshinXDsmlSpecification.g:62:1: ruleHenshinXDsmlSpecification : ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ;
    public final void ruleHenshinXDsmlSpecification() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:66:2: ( ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) )
            // InternalHenshinXDsmlSpecification.g:67:2: ( ( rule__HenshinXDsmlSpecification__Group__0 ) )
            {
            // InternalHenshinXDsmlSpecification.g:67:2: ( ( rule__HenshinXDsmlSpecification__Group__0 ) )
            // InternalHenshinXDsmlSpecification.g:68:3: ( rule__HenshinXDsmlSpecification__Group__0 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 
            // InternalHenshinXDsmlSpecification.g:69:3: ( rule__HenshinXDsmlSpecification__Group__0 )
            // InternalHenshinXDsmlSpecification.g:69:4: rule__HenshinXDsmlSpecification__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleHenshinXDsmlSpecification"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__0"
    // InternalHenshinXDsmlSpecification.g:77:1: rule__HenshinXDsmlSpecification__Group__0 : rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1 ;
    public final void rule__HenshinXDsmlSpecification__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:81:1: ( rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1 )
            // InternalHenshinXDsmlSpecification.g:82:2: rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__HenshinXDsmlSpecification__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__0"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__0__Impl"
    // InternalHenshinXDsmlSpecification.g:89:1: rule__HenshinXDsmlSpecification__Group__0__Impl : ( 'metamodel' ) ;
    public final void rule__HenshinXDsmlSpecification__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:93:1: ( ( 'metamodel' ) )
            // InternalHenshinXDsmlSpecification.g:94:1: ( 'metamodel' )
            {
            // InternalHenshinXDsmlSpecification.g:94:1: ( 'metamodel' )
            // InternalHenshinXDsmlSpecification.g:95:2: 'metamodel'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__0__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__1"
    // InternalHenshinXDsmlSpecification.g:104:1: rule__HenshinXDsmlSpecification__Group__1 : rule__HenshinXDsmlSpecification__Group__1__Impl rule__HenshinXDsmlSpecification__Group__2 ;
    public final void rule__HenshinXDsmlSpecification__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:108:1: ( rule__HenshinXDsmlSpecification__Group__1__Impl rule__HenshinXDsmlSpecification__Group__2 )
            // InternalHenshinXDsmlSpecification.g:109:2: rule__HenshinXDsmlSpecification__Group__1__Impl rule__HenshinXDsmlSpecification__Group__2
            {
            pushFollow(FOLLOW_4);
            rule__HenshinXDsmlSpecification__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__1"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__1__Impl"
    // InternalHenshinXDsmlSpecification.g:116:1: rule__HenshinXDsmlSpecification__Group__1__Impl : ( '\"' ) ;
    public final void rule__HenshinXDsmlSpecification__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:120:1: ( ( '\"' ) )
            // InternalHenshinXDsmlSpecification.g:121:1: ( '\"' )
            {
            // InternalHenshinXDsmlSpecification.g:121:1: ( '\"' )
            // InternalHenshinXDsmlSpecification.g:122:2: '\"'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getQuotationMarkKeyword_1()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getQuotationMarkKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__1__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__2"
    // InternalHenshinXDsmlSpecification.g:131:1: rule__HenshinXDsmlSpecification__Group__2 : rule__HenshinXDsmlSpecification__Group__2__Impl rule__HenshinXDsmlSpecification__Group__3 ;
    public final void rule__HenshinXDsmlSpecification__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:135:1: ( rule__HenshinXDsmlSpecification__Group__2__Impl rule__HenshinXDsmlSpecification__Group__3 )
            // InternalHenshinXDsmlSpecification.g:136:2: rule__HenshinXDsmlSpecification__Group__2__Impl rule__HenshinXDsmlSpecification__Group__3
            {
            pushFollow(FOLLOW_3);
            rule__HenshinXDsmlSpecification__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__2"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__2__Impl"
    // InternalHenshinXDsmlSpecification.g:143:1: rule__HenshinXDsmlSpecification__Group__2__Impl : ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_2 ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:147:1: ( ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_2 ) ) )
            // InternalHenshinXDsmlSpecification.g:148:1: ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_2 ) )
            {
            // InternalHenshinXDsmlSpecification.g:148:1: ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_2 ) )
            // InternalHenshinXDsmlSpecification.g:149:2: ( rule__HenshinXDsmlSpecification__MetamodelAssignment_2 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelAssignment_2()); 
            // InternalHenshinXDsmlSpecification.g:150:2: ( rule__HenshinXDsmlSpecification__MetamodelAssignment_2 )
            // InternalHenshinXDsmlSpecification.g:150:3: rule__HenshinXDsmlSpecification__MetamodelAssignment_2
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__MetamodelAssignment_2();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelAssignment_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__2__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__3"
    // InternalHenshinXDsmlSpecification.g:158:1: rule__HenshinXDsmlSpecification__Group__3 : rule__HenshinXDsmlSpecification__Group__3__Impl rule__HenshinXDsmlSpecification__Group__4 ;
    public final void rule__HenshinXDsmlSpecification__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:162:1: ( rule__HenshinXDsmlSpecification__Group__3__Impl rule__HenshinXDsmlSpecification__Group__4 )
            // InternalHenshinXDsmlSpecification.g:163:2: rule__HenshinXDsmlSpecification__Group__3__Impl rule__HenshinXDsmlSpecification__Group__4
            {
            pushFollow(FOLLOW_5);
            rule__HenshinXDsmlSpecification__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__3"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__3__Impl"
    // InternalHenshinXDsmlSpecification.g:170:1: rule__HenshinXDsmlSpecification__Group__3__Impl : ( '\"' ) ;
    public final void rule__HenshinXDsmlSpecification__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:174:1: ( ( '\"' ) )
            // InternalHenshinXDsmlSpecification.g:175:1: ( '\"' )
            {
            // InternalHenshinXDsmlSpecification.g:175:1: ( '\"' )
            // InternalHenshinXDsmlSpecification.g:176:2: '\"'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getQuotationMarkKeyword_3()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getQuotationMarkKeyword_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__3__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__4"
    // InternalHenshinXDsmlSpecification.g:185:1: rule__HenshinXDsmlSpecification__Group__4 : rule__HenshinXDsmlSpecification__Group__4__Impl ;
    public final void rule__HenshinXDsmlSpecification__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:189:1: ( rule__HenshinXDsmlSpecification__Group__4__Impl )
            // InternalHenshinXDsmlSpecification.g:190:2: rule__HenshinXDsmlSpecification__Group__4__Impl
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__4__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__4"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__4__Impl"
    // InternalHenshinXDsmlSpecification.g:196:1: rule__HenshinXDsmlSpecification__Group__4__Impl : ( ( ( rule__HenshinXDsmlSpecification__Group_4__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_4__0 )* ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:200:1: ( ( ( ( rule__HenshinXDsmlSpecification__Group_4__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_4__0 )* ) ) )
            // InternalHenshinXDsmlSpecification.g:201:1: ( ( ( rule__HenshinXDsmlSpecification__Group_4__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_4__0 )* ) )
            {
            // InternalHenshinXDsmlSpecification.g:201:1: ( ( ( rule__HenshinXDsmlSpecification__Group_4__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_4__0 )* ) )
            // InternalHenshinXDsmlSpecification.g:202:2: ( ( rule__HenshinXDsmlSpecification__Group_4__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_4__0 )* )
            {
            // InternalHenshinXDsmlSpecification.g:202:2: ( ( rule__HenshinXDsmlSpecification__Group_4__0 ) )
            // InternalHenshinXDsmlSpecification.g:203:3: ( rule__HenshinXDsmlSpecification__Group_4__0 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_4()); 
            // InternalHenshinXDsmlSpecification.g:204:3: ( rule__HenshinXDsmlSpecification__Group_4__0 )
            // InternalHenshinXDsmlSpecification.g:204:4: rule__HenshinXDsmlSpecification__Group_4__0
            {
            pushFollow(FOLLOW_6);
            rule__HenshinXDsmlSpecification__Group_4__0();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_4()); 

            }

            // InternalHenshinXDsmlSpecification.g:207:2: ( ( rule__HenshinXDsmlSpecification__Group_4__0 )* )
            // InternalHenshinXDsmlSpecification.g:208:3: ( rule__HenshinXDsmlSpecification__Group_4__0 )*
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_4()); 
            // InternalHenshinXDsmlSpecification.g:209:3: ( rule__HenshinXDsmlSpecification__Group_4__0 )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==13) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalHenshinXDsmlSpecification.g:209:4: rule__HenshinXDsmlSpecification__Group_4__0
            	    {
            	    pushFollow(FOLLOW_6);
            	    rule__HenshinXDsmlSpecification__Group_4__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_4()); 

            }


            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__4__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_4__0"
    // InternalHenshinXDsmlSpecification.g:219:1: rule__HenshinXDsmlSpecification__Group_4__0 : rule__HenshinXDsmlSpecification__Group_4__0__Impl rule__HenshinXDsmlSpecification__Group_4__1 ;
    public final void rule__HenshinXDsmlSpecification__Group_4__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:223:1: ( rule__HenshinXDsmlSpecification__Group_4__0__Impl rule__HenshinXDsmlSpecification__Group_4__1 )
            // InternalHenshinXDsmlSpecification.g:224:2: rule__HenshinXDsmlSpecification__Group_4__0__Impl rule__HenshinXDsmlSpecification__Group_4__1
            {
            pushFollow(FOLLOW_4);
            rule__HenshinXDsmlSpecification__Group_4__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group_4__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_4__0"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_4__0__Impl"
    // InternalHenshinXDsmlSpecification.g:231:1: rule__HenshinXDsmlSpecification__Group_4__0__Impl : ( 'step' ) ;
    public final void rule__HenshinXDsmlSpecification__Group_4__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:235:1: ( ( 'step' ) )
            // InternalHenshinXDsmlSpecification.g:236:1: ( 'step' )
            {
            // InternalHenshinXDsmlSpecification.g:236:1: ( 'step' )
            // InternalHenshinXDsmlSpecification.g:237:2: 'step'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_4_0()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_4_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_4__0__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_4__1"
    // InternalHenshinXDsmlSpecification.g:246:1: rule__HenshinXDsmlSpecification__Group_4__1 : rule__HenshinXDsmlSpecification__Group_4__1__Impl ;
    public final void rule__HenshinXDsmlSpecification__Group_4__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:250:1: ( rule__HenshinXDsmlSpecification__Group_4__1__Impl )
            // InternalHenshinXDsmlSpecification.g:251:2: rule__HenshinXDsmlSpecification__Group_4__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group_4__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_4__1"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_4__1__Impl"
    // InternalHenshinXDsmlSpecification.g:257:1: rule__HenshinXDsmlSpecification__Group_4__1__Impl : ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group_4__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:261:1: ( ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 ) ) )
            // InternalHenshinXDsmlSpecification.g:262:1: ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 ) )
            {
            // InternalHenshinXDsmlSpecification.g:262:1: ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 ) )
            // InternalHenshinXDsmlSpecification.g:263:2: ( rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsAssignment_4_1()); 
            // InternalHenshinXDsmlSpecification.g:264:2: ( rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 )
            // InternalHenshinXDsmlSpecification.g:264:3: rule__HenshinXDsmlSpecification__UnitsAssignment_4_1
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__UnitsAssignment_4_1();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsAssignment_4_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_4__1__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__MetamodelAssignment_2"
    // InternalHenshinXDsmlSpecification.g:273:1: rule__HenshinXDsmlSpecification__MetamodelAssignment_2 : ( ( RULE_ID ) ) ;
    public final void rule__HenshinXDsmlSpecification__MetamodelAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:277:1: ( ( ( RULE_ID ) ) )
            // InternalHenshinXDsmlSpecification.g:278:2: ( ( RULE_ID ) )
            {
            // InternalHenshinXDsmlSpecification.g:278:2: ( ( RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:279:3: ( RULE_ID )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageCrossReference_2_0()); 
            // InternalHenshinXDsmlSpecification.g:280:3: ( RULE_ID )
            // InternalHenshinXDsmlSpecification.g:281:4: RULE_ID
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageIDTerminalRuleCall_2_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageIDTerminalRuleCall_2_0_1()); 

            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageCrossReference_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__MetamodelAssignment_2"


    // $ANTLR start "rule__HenshinXDsmlSpecification__UnitsAssignment_4_1"
    // InternalHenshinXDsmlSpecification.g:292:1: rule__HenshinXDsmlSpecification__UnitsAssignment_4_1 : ( ( RULE_ID ) ) ;
    public final void rule__HenshinXDsmlSpecification__UnitsAssignment_4_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:296:1: ( ( ( RULE_ID ) ) )
            // InternalHenshinXDsmlSpecification.g:297:2: ( ( RULE_ID ) )
            {
            // InternalHenshinXDsmlSpecification.g:297:2: ( ( RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:298:3: ( RULE_ID )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_4_1_0()); 
            // InternalHenshinXDsmlSpecification.g:299:3: ( RULE_ID )
            // InternalHenshinXDsmlSpecification.g:300:4: RULE_ID
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitIDTerminalRuleCall_4_1_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitIDTerminalRuleCall_4_1_0_1()); 

            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_4_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__UnitsAssignment_4_1"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000002002L});

}